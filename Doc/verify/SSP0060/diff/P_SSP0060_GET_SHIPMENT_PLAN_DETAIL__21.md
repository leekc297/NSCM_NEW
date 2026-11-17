# SSP0060 · SSP0060_GET_SHIPMENT_PLAN_DETAIL ↔ PKG_SSP0060.P_SSP0060_GET_SHIPMENT_PLAN_DETAIL

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 division_id) — AS-IS 1행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 auto · 키 division_id · golden 집합 판정 DIFF
- 호출 #21 sheet=planDetail btn=SEARCH user=minyonglee1 FE 응답 행 0 · 원천 Doc\verify\SSP0060\calls\_verify_저장_경로_F1_실패_H10_취소_H11_로딩_F2_붙여넣기__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "companyId": "GM00", "fromSite": "VP_GM01-A", "itemId": "ECE1592F1-01-H01", "productLevel1": "-", "planStartYyyymmdd": "20261009", "dblFlag": "Y", "language": "KO", "programId": "SSP0060", "sheetName": "Shipment Plan Detail", "debugMode": "F", "requestor": "", "toSite": "US02279100_82-P", "transportMode": "TRK", "incoterms": "FCA", "fcstType": "MPS", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261009", "realFlag": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_company_id": "GM00", "p_from_site": "VP_GM01-A", "p_item_id": "ECE1592F1-01-H01", "p_product_level1": "-", "p_requestor": "", "p_to_site": "US02279100_82-P", "p_transport_mode": "TRK", "p_incoterms": "FCA", "p_fcst_type": "MPS", "p_plan_start_yyyymmdd": "20261009", "p_from_yyyymmdd": "20261009", "p_to_yyyymmdd": "20261009", "p_dbl_flag": "Y", "p_real_flag": "Y", "p_language": "KO", "p_program_id": "SSP0060", "p_sheet_name": "Shipment Plan Detail", "debug_mode": "F"}`

### 결과셋 1  As-is 1행 ↔ To-Be O_RC1 0행
- 행수 불일치 1 ↔ 0
- 값 차이: As-is 전용 1행 / To-Be 전용 0행 (공통 컬럼 68)
| 측 | division_id | erp_so_no | erp_do_no | shipment_status | PRODUCT_LEVEL1 | item_id | nick_name | from_site | to_site | from_site_description | to_site_description | PROJECT_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | 4570340963 |  | C |  | ECE1592F1-01-H01 | JF2-H01 | VP_GM01-A | US02279100_82-P | virtual plant(GM01)-Cell | PeopleWorks-US CHI |  |
- 데이터 기준: 공통 0행 · AS-IS 전용 1행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
