# SCP0041 · SCP0041_GET_STOCK_OSP ↔ PKG_SCP0041.P_SCP0041_GET_STOCK_OSP

- 실행 2026-11-14 15:25:22 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 29735행 전 컬럼 일치 · 단독행 AS-IS 10 / TO-BE 510 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+SCM_SITE_ID+SITE_DESCRIPTION+ITEM_ID+QTY+nick_name+YYYYMMDD · golden 집합 판정 DIFF
- 호출 #5 sheet=Osp Stock btn=SEARCH user=minyonglee1 FE 응답 행 None · 원천 Doc\verify\SCP0041\calls\_trace_A10_조회_전_그리드_K4_버튼_구성_X-REOPEN_닫기_재오픈_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "plantSiteId": "", "itemId": "", "fromYyyymmdd": "20211109", "toYyyymmdd": "20271009"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_plant_site_id": "", "p_item_id": "", "p_from_yyyymmdd": "20211109", "p_to_yyyymmdd": "20271009"}`

### 결과셋 1  As-is 29745행 ↔ To-Be O_RC1 30245행
- 행수 불일치 29745 ↔ 30245
- 값 차이: As-is 전용 29745행 / To-Be 전용 30245행 (공통 컬럼 15)
| 측 | DIVISION_ID | SCM_SITE_ID | SITE_DESCRIPTION | ITEM_ID | nick_name | YYYYMMDD | ATTRIBUTE1 | QTY | ATTRIBUTE2 | COMMENT | ATTRIBUTE3 | CREATED_BY |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | ACER_CN_CKG | acer_CN_CKG | MPPACE23A81N | AP23A8L | 2025-06-15 |  | 19560 |  | ACER |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-14 |  | 531166 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-21 |  | 597751 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-28 |  | 742290 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-05 |  | 637405 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-12 |  | 312328 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-19 |  | 166431 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-02 |  | 1039505 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-09 |  | 654363 |  |  |  |  |
| A | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-16 |  | 729823 |  |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-14 | / | 531166 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-21 | / | 597751 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-11-28 | / | 742290 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-05 | / | 637405 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-12 | / | 312328 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2021-12-19 | / | 166431 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-02 | / | 1039505 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-09 | / | 654363 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-16 | / | 729823 | / |  |  |  |
| T | 40 | CN00254300_40-P | NEXCON_CN_NJ | MCCH125020A1 | H26A | 2022-01-23 | / | 549046 | / |  |  |  |
- 데이터 기준: 공통 29735행 · AS-IS 전용 10행 · TO-BE 전용 510행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 29735행의 상대 순서): 불일치 — 첫 차이 r18341: AS-IS=['40', 'HP_CN_CKG', 'HP_CN_CKG', 'MPCHPPPEEX1C', 'PU08073(HG2N/8)', '2021-11-28'] ↔ TO-BE=['40', 'HP1_NL_BEJ', 'HP1_NL_BEJ', 'MPCHPPJC041C', 'JC04041(C4/4)', '2022-05-29'] · 센티널 차이 컬럼 ATTRIBUTE1(29735행 AS-IS ''↔TO-BE '/'), ATTRIBUTE2(29735행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)
