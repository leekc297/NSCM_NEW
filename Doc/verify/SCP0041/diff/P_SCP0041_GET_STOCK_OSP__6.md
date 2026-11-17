# SCP0041 · SCP0041_GET_STOCK_OSP ↔ PKG_SCP0041.P_SCP0041_GET_STOCK_OSP

- 실행 2026-11-14 15:25:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 17870행 전 컬럼 일치 · 단독행 AS-IS 3 / TO-BE 816 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+SCM_SITE_ID+SITE_DESCRIPTION+ITEM_ID+QTY+YYYYMMDD · golden 집합 판정 DIFF
- 호출 #6 sheet=Osp Stock btn=SEARCH user=minyonglee1 FE 응답 행 18723 · 원천 Doc\verify\SCP0041\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "plantSiteId": "", "itemId": "", "fromYyyymmdd": "20211109", "toYyyymmdd": "20271009"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_plant_site_id": "", "p_item_id": "", "p_from_yyyymmdd": "20211109", "p_to_yyyymmdd": "20271009"}`

### 결과셋 1  As-is 17909행 ↔ To-Be O_RC1 18722행
- 행수 불일치 17909 ↔ 18722
- 값 차이: As-is 전용 16307행 / To-Be 전용 17120행 (공통 컬럼 15)
| 측 | DIVISION_ID | SCM_SITE_ID | SITE_DESCRIPTION | ITEM_ID | nick_name | YYYYMMDD | ATTRIBUTE1 | QTY | ATTRIBUTE2 | COMMENT | ATTRIBUTE3 | CREATED_BY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-04-27 |  | 33 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-13 |  | 15 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-20 |  | 52 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-27 |  | 2 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-08-03 |  | 2 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-08-10 |  | 2 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-11-30 |  | 11 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-09-17 |  | 7236 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-09-24 |  | 7236 |  |  |  |  |
| A | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-10-08 |  | 7399 |  |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-04-27 | / | 33 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-13 | / | 15 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-20 | / | 52 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-07-27 | / | 2 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-08-03 | / | 2 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-08-10 | / | 2 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | EA102156PG01 | JF2S CPNT CMA | 2025-11-30 | / | 11 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-09-17 | / | 7236 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-09-24 | / | 7236 | / |  |  |  |
| T | 82 | CN00249500-P | Peopleworks_CN | ECE0566F1-01 | JF1 | 2023-10-08 | / | 7399 | / |  |  |  |
- 데이터 기준: 공통 17906행 · AS-IS 전용 3행 · TO-BE 전용 816행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 17906행의 상대 순서): 불일치 — 첫 차이 r64: AS-IS=['82', 'CN00249500-P', 'Peopleworks_CN', 'ECE0566F1-01', 'JF1', '2024-09-01'] ↔ TO-BE=['82', 'CN00249500-P', 'Peopleworks_CN', 'ECE0566F1-01', 'JF1', '2024-09-01'] · 센티널 차이 컬럼 ATTRIBUTE1(16133행 AS-IS ''↔TO-BE '/'), ATTRIBUTE2(15970행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
