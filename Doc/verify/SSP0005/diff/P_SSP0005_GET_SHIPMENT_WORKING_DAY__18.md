# SSP0005 · SSP0005_GET_SHIPMENT_WORKING_DAY ↔ PKG_SSP0005.P_SSP0005_GET_SHIPMENT_WORKING_DAY

- 실행 2026-11-20 08:53:29 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 company_id+division_id) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 cleanup_spec.json · 키 company_id+division_id · golden 집합 판정 PASS
- 호출 #18 sheet=Shipment Working Day btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0005\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"fromYyyymmdd": "20261120", "toYyyymmdd": "20271114", "divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD", "companyId": "AA00", "debugMode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_from_yyyymmdd": "20261120", "p_to_yyyymmdd": "20271114", "p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD", "p_company_id": "AA00", "debug_mode": "F"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
