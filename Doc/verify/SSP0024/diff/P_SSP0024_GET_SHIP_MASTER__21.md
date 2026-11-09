# SSP0024 · (AS-IS 짝 없음) ↔ PKG_SSP0024.P_SSP0024_GET_SHIP_MASTER

- 실행 2026-11-09 12:10:47 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #21 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 9 · 원천 Doc\verify\SSP0024\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSiteId": "", "materialId": "", "nickName": "", "modelId": "ECE0630N1-02,ECP0640N5-02"}`
- SKIP: sp_pair.csv 에 이 TO-BE proc 의 AS-IS 짝 없음 — gen_param_map.py 또는 source=manual 행 추가
