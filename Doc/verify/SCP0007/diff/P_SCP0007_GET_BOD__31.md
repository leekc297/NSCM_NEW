# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 6행 전 컬럼 일치 · 키 원천 auto · 키 BOD_ID · golden 집합 판정 PASS
- 호출 #31 sheet=bod btn=SEARCH user=minyonglee1 FE 응답 행 7 · 원천 Doc\verify\SCP0007\calls\_verify_레이아웃_조회_묶음_H4_N1_G1_L2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HG", "fromSite": "ALL", "toSite": "ALL", "incoterms": "ALL", "incotermsSsp": "ALL", "transMode": "ALL", "inputStatus": "C", "validYn": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81_HG", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_to_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_incoterms_ssp: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_trans_mode: 'ALL'→''(all_semantics: 빈 값 = 전체)

### 결과셋 1  As-is 6행 ↔ To-Be O_RC 6행
- 일치
- 데이터 기준: 공통 6행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['81_HG', '18143', '', 'DAP', 'DAP', 'HG00-E'] ↔ TO-BE=['81_HG', '20755', 'HKMC', 'DAP', 'DAP', 'HG00-A']
