# SCP0127 · SCP0127_GET_SEARCH_INFO ↔ PKG_SCP0127.P_SCP0127_GET_SEARCH_INFO

- 실행 2026-11-07 21:45:56 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 46행 전 컬럼 일치 · 키 원천 db_resultsets.csv is_nullable=0 · 키 CODE+NAME+DIVISION_ID · golden 집합 판정 DIFF
- 호출 #1 sheet=init btn=SEARCH user=minyonglee1 FE 응답 행 2835 · 원천 Doc\verify\SCP0127\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "", "scmSiteId": ""}`
- AS-IS 인자(번역): `{"p_division_id": "ALL", "p_site_id": "Fabricators_CN_QIN"}` · 번역 메모: p_division_id: ''→'ALL'(all_semantics) · p_site_id: 본문에 siteId 없음 → default 'Fabricators_CN_QIN'
- TO-BE 인자 중 값 없음(NULL 전달): P_SITE_ID

### 결과셋 1  As-is 46행 ↔ To-Be O_RC1 46행
- 일치
- 데이터 기준: 공통 46행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 46행의 상대 순서): 일치

### 결과셋 2  As-is 2670행 ↔ To-Be O_RC2 2731행
- 행수 불일치 2670 ↔ 2731
- 값 차이: As-is 전용 5행 / To-Be 전용 66행 (공통 컬럼 3)
| 측 | DIVISION_ID | CODE | NAME |
|---|---|---|---|
| A | 40 | HUAYOU_CN_NJG | HUAYOU_CN_NJG |
| A | 40 | HUAYOU_CN_NJP | HUAYOU_CN_NJP |
| A | 40 | HUAYOU_HK_YUE | HUAYOU_HK_YUE |
| A | 40 | HUAYOU_SG_SIN | HUAYOU_SG_SIN |
| A | 82 | DTE_US_DT7 | DTE_US_DT7 |
| T | 40 | ABS_US_BUX | ABS_US_BUX |
| T | 40 | AC00-A | AC00-A |
| T | 40 | AJ상사_AB_TES | AJ상사_AB_TES |
| T | 40 | AJ상사_AC_TES | AJ상사_AC_TES |
| T | 40 | AJ상사_AE_AAN | AJ상사_AE_AAN |
| T | 40 | AJ상사_AE_ABU | AJ상사_AE_ABU |
| T | 40 | AT00-A | AT00-A |
| T | 40 | Anjin_AA_TES | Anjin_AA_TES |
| T | 40 | Anjin_AK_TES | Anjin_AK_TES |
| T | 40 | BMZ_DE_FRA | BMZ_DE_FRA |
- 데이터 기준: 공통 2665행 · AS-IS 전용 5행 · TO-BE 전용 66행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2665행의 상대 순서): 불일치 — 첫 차이 r249: AS-IS=['40', 'Audi_DE_ING', 'Audi_DE_ING'] ↔ TO-BE=['81', 'Audi_DE_ING', 'Audi_DE_ING']

### 결과셋 3  As-is 53행 ↔ To-Be O_RC3 53행
- 일치
- 데이터 기준: 공통 53행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 53행의 상대 순서): 일치

### 결과셋 4  As-is 2행 ↔ To-Be O_RC4 2행
- 일치
- 데이터 기준: 공통 2행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치

### 결과셋 5  As-is 2행 ↔ To-Be O_RC5 2행
- 일치
- 데이터 기준: 공통 2행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치

### 결과셋 6  As-is 200000행 ↔ To-Be O_RC6 0행
- 행수 불일치 200000 ↔ 0
- 값 차이: As-is 전용 199999행 / To-Be 전용 0행 (공통 컬럼 2)
| 측 | DIVISION_ID | ITEM_ID |
|---|---|---|
| A | 11 | APBMW12VA-A2-D01 |
| A | 11 | CB018650LP |
| A | 11 | EABS00024AA |
| A | 11 | EABS00138AA |
| A | 11 | EABS00202AA |
| A | 11 | EABS00311AA |
| A | 11 | EABS00313AA |
| A | 11 | EABS00316AA |
| A | 11 | EACV00059AA |
| A | 11 | EAPJ00193AA |
- 데이터 기준: 공통 0행 · AS-IS 전용 200000행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급) · ⚠ 행 상한 200000 도달
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
