# SSP0021 · SSP0021_GET_SHIPMENT_PLAN ↔ PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN

- 실행 2026-11-15 02:40:13 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #22 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 0 · 원천 Doc\verify\SSP0021\calls\_verify_필터_항목_연속_조회_본문_K1_G6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "companyId": "HQ00", "fromSite": "", "planStartYyyymmdd": "20260919", "fromYyyymmdd": "20260919", "toYyyymmdd": "20261113", "itemId": "E2E", "userId": "minyonglee1", "programId": "SSP0021", "sheetName": "Shipment Plan", "realFlag": "N"}`
- SKIP: kind=SAVE — GET 만 실행(쓰기 SP 실행 금지) ·  · kind 근거: DML 대상 ['C', 'SET']
