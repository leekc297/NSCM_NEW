# SSP0021 · SSP0021_GET_SHIPMENT_PLAN ↔ PKG_SSP0021.P_SSP0021_GET_SHIPMENT_PLAN

- 실행 2026-11-15 02:40:13 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #13 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 18 · 원천 Doc\verify\SSP0021\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HG", "companyId": "HG00", "fromSite": "", "planStartYyyymmdd": "20261009", "fromYyyymmdd": "20261009", "toYyyymmdd": "20261203", "itemId": "", "userId": "minyonglee1", "programId": "SSP0021", "sheetName": "Shipment Plan", "realFlag": "Y"}`
- SKIP: kind=SAVE — GET 만 실행(쓰기 SP 실행 금지) ·  · kind 근거: DML 대상 ['C', 'SET']
