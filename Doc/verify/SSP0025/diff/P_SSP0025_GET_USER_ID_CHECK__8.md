# SSP0025 · (AS-IS 짝 없음) ↔ PKG_SSP0025.P_SSP0025_GET_USER_ID_CHECK

- 실행 2026-11-09 11:50:05 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #8 sheet=main btn=USER_CHECK user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SSP0025\calls\_verify_CRUD_필수_공란_실제_저장_시도_E3_필수_채워_실제_저장_재조회_값_보존_정리_F1_F2_F4_F6__0.json
- TO-BE 인자(FE 본문): `{"userId": "kyb0716"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
