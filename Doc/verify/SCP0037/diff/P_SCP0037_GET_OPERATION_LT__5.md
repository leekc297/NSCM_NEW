# SCP0037 · SCP0037_GET_OPERATION_LT ↔ PKG_SCP0037.P_SCP0037_GET_OPERATION_LT

- 실행 2026-11-07 18:17:32 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 64행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+SCM_SITE_ID+ITEM_ID+LT_OPERATION · golden 집합 판정 PASS
- 호출 #5 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3081 · 원천 Doc\verify\SCP0037\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "scmSiteId": "ALL", "itemId": "ALL", "scmValidYn": "ALL", "ltOperation": "CTP_LT"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_scm_site_id": "", "p_item_id": "", "p_scm_valid_yn": "", "p_lt_operation": "CTP_LT"}` · 번역 메모: p_scm_site_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_item_id: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_scm_valid_yn: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 64행 ↔ To-Be O_RC1 64행
- 일치
- 데이터 기준: 공통 64행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 64행의 상대 순서): 불일치 — 첫 차이 r9: AS-IS=['81', 'NA00-A', 'NA00-A', 'AAEN1066I-A1-100', 'E66C-100', 'CTP_LT'] ↔ TO-BE=['81', 'HQ07-A', 'HQ07-A', 'AALF1015I-B1', 'LV15A', 'CTP_LT']

### 결과셋 2  As-is 3016행 ↔ To-Be O_RC2 3016행
- 일치
- 데이터 기준: 공통 3016행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3016행의 상대 순서): 일치
